#!/usr/bin/perl -w

use strict;
use warnings;
use LWP::Simple;

my $file="./name.list.new";
open (my $INPUT, $file) || die "Couldn't open $file\n";
my $url;
my  @new;
while (my $line=<$INPUT>)
{  chomp $line;

   $url="http://www.ncbi.nlm.nih.gov/protein/$line";
   my $content = get($url) or die "cannot retrieve code\n";

   if($content =~ m/replaced by/i) {
    @new = $content =~ /replaced by (.*)\<\/span\>/g;
   print "$line replaced by: @new\n";
 } elsif ($content =~ m/Record removed/i) {
   print "Record removed: $line\n";
 }
}
close($INPUT);
