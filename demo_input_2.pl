#!/usr/bin/perl
use strict;
use warnings;

print "Enter the log file name (e.g., Common:1:1:MarketManager:1.log): ";
my $log_file = <STDIN>;
chomp $log_file;

my $grep_output_file = "grep_output_input_2.txt";
my $final_output_file = "final_output_input_2.txt";

print "Enter the MESSAGE to look for (SMsg:MM_Filter): ";
my $pattern1 = <STDIN>;
chomp $pattern1;

print "Enter the maximum number of lines to keep in each section (19): ";
my $max_section_lines = <STDIN>;
chomp $max_section_lines;

print "Enter the pattern to FILTER (Trading Cycle ID = Standard): ";
my $pattern2 = <STDIN>;
chomp $pattern2;

print "Enter the number of lines to capture in each section (13): ";
my $max_lines = <STDIN>;
chomp $max_lines;

open my $grep_output_fh, '>', $grep_output_file or die "Could not open $grep_output_file: $!";
open my $final_output_fh, '>', $final_output_file or die "Could not open $final_output_file: $!";
open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";

my $inside_section = 0; # A flag to indicate whether the code is currently inside a section.
my $capture_lines = 0; # A counter to track the number of lines captured in the current section.
my @section; # An array to store the lines in the current section.

while (my $line = <$log_fh>) {
    if ($line =~ /$pattern1/) {
        $inside_section = 1;
        $capture_lines = 0;
        @section = ();  # Start a new section
    }
    if ($inside_section) {
        push @section, $line;
        print $grep_output_fh $line;  # Save to grep_output.txt

        if ($capture_lines >= $max_lines && $line =~ /$pattern2/) {
            print $final_output_fh @section;  # Save to final_output.txt
        }

        if ($capture_lines >= $max_section_lines) {
            shift @section;  # Remove the oldest line from the section
        }
        $capture_lines++;
    }
}

close $log_fh;
close $grep_output_fh;
close $final_output_fh;

print "Grep output has been saved to $grep_output_file\n";
print "Final output has been saved to $final_output_file\n";