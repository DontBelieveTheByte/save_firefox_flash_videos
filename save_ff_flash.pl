#!/usr/bin/perl
####
#  This script will save all currently open Flash videos in firefox.
#  Published under the GPLv3 license or later versions.
#  Full license is available here : https://www.gnu.org/licenses/gpl.html
#  (c) J-F B 2013
#
#   This program is free software: you can redistribute it and/or modify 
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
####
use strict;
use File::Copy;
my $savePath;
my @lsofOutput;
#Save directory defaults to your Desktop, or is set by command line path argument.
$savePath = ($ARGV[0]) ? $ARGV[0] : $ENV{HOME}."/Desktop";
#Make sure the path exists and is writable.
if (!-d $savePath && !-w $savePath){
		die "Cannot use specified directory" . $savePath . ".\n Either doesn't exist or unwritable.'\n";
}
#Call lsof and fill all videos into an array.
if (-e '/usr/bin/lsof' && -x '/usr/bin/lsof'){
		print "Looking for videos...\n";
		@lsofOutput = `lsof | grep Flash`;
} else {
		die "The lsof command doesn't seem available on this system."
}
print @lsofOutput;
if (@lsofOutput){
#If array is not empty, loop through the array and attempt to save video files to disk.
				foreach my $video (@lsofOutput){
						my @videoArr = split(/\s+/,$video);
						my $from = "/proc/".$videoArr[1]."/fd/". substr($videoArr[3], 0, -1);
						my $to = $savePath."/".substr($videoArr[8],5,-1).".flv";
						copy($from,$to) ?  print "Saved $from to $to\n" : warn "Copying of $from to $savePath failed, might not be a valid file.\n";
					}
} else{
		print "No video was found during this instance.\n";
}
#End of script
