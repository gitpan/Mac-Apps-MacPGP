#!perl
#-----------------------------------------------------------------#
#  macpgp.pl
#  pudge
#  
#  Interface to MacPGP263
#
#  Created:       Chris Nandor (pudge@pobox.com)         31-Dec-96
#  Last Modified: Chris Nandor (pudge@pobox.com)         01-Jan-97
#-----------------------------------------------------------------#
my($macpgp,$type,$mess,$pass,$recv,@recs,$usid,$sign,$read,$outp);
use Mac::Apps::MacPGP;
$macpgp = new MacPGP;
$macpgp->switchapp(1,'R*ch'); #switches to MacPGP and then BBEdit when finished
&doMain;
#&doVersion;
#-----------------------------------------------------------------
sub doMain {
	while (<>) {
		chomp;
		if (/^-----BEGIN PGP /) {
			$mess = $_;
			while (<>) {
				$mess .= $_;
			}
			&doDecrypt;
		}
		s/^(.)//;
		$l = $1;
		s/\Q$l\E$//;
		@r = split(/\Q$l\E/, $_);
		$type = $r[0];
		$pass = $r[1];
		@recs = split(/ /,$r[2]);
		$recv = \@recs;
		last;
	}
	while (<>) {
		$mess .= $_;
	}
	&doRecv		if (!$$recv[0] && $type eq 'e');
	&doEncrypt	if ($type eq 'e' && $recv && $mess);
	&doSign		if ($type eq 's' && $recv && $mess);
	&doDecrypt	if ($type eq 'd' && $mess);
	print $macpgp->getresults('result');  #defaults to 'result', too
#	%hash = $macpgp->getresultsall;   #un-comment to see all available result parameters
#	foreach (keys %hash) {
#		print "\n\n$_ = $hash{$_}\n";
#	}
}
#-----------------------------------------------------------------
sub doRecv {
	$recv = $macpgp->keyring('selk','Select a user to encrypt to');
}
#-----------------------------------------------------------------
sub doEncrypt {
	$type = 'ncrd';
	$sign = 'incl';
	$read = 'norm';
	$outp = '';
	$lati = 0;
	$wrap = 0;
	$alns = 0;
	$tabx = 4;
	$mdal = 'MD5';
	$wsrc = 0;
	$cpas = '';
	$copt = 'sdf';
	$macpgp->encrypt($type,$mess,$recv,$pass,$usid,$sign,$read,$outp, $lati,$wrap,$alns,$tabx,$mdal,$wsrc,$copt);
}
#-----------------------------------------------------------------
sub doSign {
	$type = 'sigd';
	$sign = 'clea';
	$read = 'norm';
	$outp = '';
	$lati = 't';
	$wrap = 0;
	$alns = 0;
	$tabx = 4;
	$mdal = 'MD5';
	$wsrc = 'f';
	$macpgp->sign($type,$mess,$pass,$usid,$sign,$read,$outp,$lati,$wrap,$alns,$tabx,$mdal,$stfx);
}
#-----------------------------------------------------------------
sub doDecrypt {
	$type = 'dcrd';
	$macpgp->decrypt($type,$mess,$pass,$scre,$nsig,$apl2,$recv);
}
#-----------------------------------------------------------------
sub doVersion {
	$macpgp->switchapp(0); #turn app switching off
	print $macpgp->getversion,"\n";
	print $macpgp->getresults;  #this will always return the same thing 
								#as the previous method returns if there is 
								#no parameter or the parameter is '----' or 'result'

	#$macpgp->getversion;print $macpgp->getresults;		#in other words, these two
	#print $macpgp->getversion;							#lines are equivalent

}
#-----------------------------------------------------------------
