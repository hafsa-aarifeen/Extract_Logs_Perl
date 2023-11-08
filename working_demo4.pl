#demo4.pl in xshell

#!/usr/bin/perl
use strict;
use warnings;

my $log_file = "Common:1:1:MarketManager:1.log";
my $grep_output_file = "grep_output.txt";
my $final_output_file = "final_output.txt";

open my $grep_output_fh, '>', $grep_output_file or die "Could not open $grep_output_file: $!";
open my $final_output_fh, '>', $final_output_file or die "Could not open $final_output_file: $!";
open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";

my $inside_section = 0; # A flag to indicate whether the code is currently inside a section.
my $capture_lines = 0; #A counter to track the number of lines captured in the current section.
my @section; #An array to store the lines in the current section.

while (my $line = <$log_fh>) {
    if ($line =~ /SMsg:MM_Filter/) {
        $inside_section = 1;
        $capture_lines = 0;
        @section = ();  # Start a new section
    }

    if ($inside_section) {
        push @section, $line;
        print $grep_output_fh $line;  # Save to grep_output.txt

        if ($capture_lines >= 13 && $line =~ /Trading Cycle ID = Standard/) {
            print $final_output_fh @section;  # Save to final_output.txt
        }

        if ($capture_lines >= 19) {
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