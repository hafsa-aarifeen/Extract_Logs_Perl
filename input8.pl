#!/usr/bin/perl
use strict;
use warnings;

print "Enter the log file: ";
my $log_file = <STDIN>;
chomp $log_file;

print "Enter the MESSAGE to look for: ";
my $message_pattern = <STDIN>;
chomp $message_pattern;

print "Enter the number of lines to capture: ";
my $lines_to_capture = <STDIN>;
chomp $lines_to_capture;

print "Enter the pattern to check for (press Enter to skip): ";
my $pattern_to_check = <STDIN>;
chomp $pattern_to_check if defined $pattern_to_check;

print "Enter the output file: ";
my $output_file = <STDIN>;
chomp $output_file;

my $inside_section = 0;
my @section;

open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";
open my $output_fh, '>', $output_file or die "Could not open $output_file: $!";

while (my $line = <$log_fh>) {
    if ($line =~ /$message_pattern/) {
        $inside_section = 1;
        @section = ();
    }

    if ($inside_section) {
        push @section, $line;
        if (@section == $lines_to_capture) {
            if (!defined $pattern_to_check || grep { /$pattern_to_check/ } @section) {
                foreach my $output_line (@section) {
                    print $output_fh $output_line;
                }
            }
            @section = ();
            $inside_section = 0;
        }
    }
}

close $log_fh;
close $output_fh;

if (-z $output_file) {
    print "$message_pattern not found in the log file. No lines captured.\n";
} else {
    print "Captured lines have been saved to $output_file\n";
}