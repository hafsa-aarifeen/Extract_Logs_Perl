#!/usr/bin/perl
use strict;
use warnings;

my $log_file = "Common:1:1:MarketManager:1.log";
my $output_file = "output_lines.txt";

open my $output_fh, '>', $output_file or die "Could not open $output_file: $!";
close $output_fh;  # Clear the output file if it already exists

my $in_section = 0;
my $lines_to_extract = 19;
my $lines_extracted = 0;

open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";

while (my $line = <$log_fh>) {
    if ($line =~ /SMsg: MM_Filter/) {
        $in_section = 1;
        $lines_extracted = 0;  # Reset lines extracted count
    }

    if ($in_section) {
        if ($line =~ /Trading Cycle ID = Standard/) {
            if ($lines_extracted >= 6) {
                $lines_extracted = 0;  # Reset lines extracted count
                last;  # Exit the loop after 19 lines
            }
            else {
                $lines_extracted++;  # Increment the lines extracted count
            }
        }

        print $output_fh $line;
    }
}

close $log_fh;
close $output_fh;

print "Lines extracted have been saved to $output_file\n";
