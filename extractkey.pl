#!perl
#-----------------------------------------------------------------#
#  extractkey.pl
#  pudge
#  
#  Put my key in the clipboard
#
#  Created:       Chris Nandor (pudge@pobox.com)         01-Jan-97
#  Last Modified: Chris Nandor (pudge@pobox.com)         08-Jan-97
#-----------------------------------------------------------------#
use Mac::Apps::MacPGP;
$macpgp = new MacPGP;
$file   = 'PowerPudge:Utilities:Files:Compress/Translate:MacPGP2.6.3 Ä:pudgetemp';
$usid   = 'pudge@pcix.com';

$macpgp->switchapp(1);  #file2clip doesn't work if MacPGP not in front
$macpgp->create($file);
$macpgp->extract($usid,$file);
print $macpgp->file2clip("$file.asc");
unlink $file;


