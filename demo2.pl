#!/usr/bin/perl
use strict;
use warnings;

my $log_file = "Common:1:1:MarketManager:1.log";
my $output_file = "output_lines.txt";

open my $output_fh, '>', $output_file or die "Could not open $output_file: $!";
close $output_fh;  # Clear the output file if it already exists

# Define the grep command
my $grep_command = 'grep -A 13 -B 6 "Trading Cycle ID = Standard" ' . $log_file;

# Execute the grep command and capture the output
my $grep_output = `$grep_command`;

# Write the output to the output file
open $output_fh, '>', $output_file or die "Could not open $output_file: $!";
print $output_fh $grep_output;
close $output_fh;

print "Grep output has been saved to $output_file\n";