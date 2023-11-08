#!/usr/bin/perl
use strict;
use warnings;

my $log_file = "Common:1:1:MarketManager:1.log";
my $output_file = "output_lines_demo4.txt";

open my $output_fh, '>', $output_file or die "Could not open $output_file: $!";

open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";

my $capture_lines = 0;
my $lines_to_capture = 0;

while (my $line = <$log_fh>) {
    if ($line =~ /SMsg: MM_Filter/) {
        $capture_lines = 1;
        $lines_to_capture = 19;  # Capture the next 19 lines
        print $output_fh $line;  # Include the trigger line in the output
    }

    if ($capture_lines) {
        print $output_fh $line;  # Include the current line in the output
        $lines_to_capture--;

        if ($lines_to_capture == 0) {
            last;  # Stop capturing after 19 lines
        }
    }
}

close $log_fh;
close $output_fh;

print "Filtered lines have been saved to $output_file\n";