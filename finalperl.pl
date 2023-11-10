#!/usr/bin/perl
use strict;
use warnings;

# Prompt the user for the config file.
print "Enter the configuration file: ";
my $config_file = <STDIN>;
chomp $config_file;

# Open and read the config file.
open my $config_fh, '<', $config_file or die "Could not open $config_file: $!";
my %config;

while (my $line = <$config_fh>) {
    chomp $line;
    my ($key, $value) = split(/\s*=\s*/, $line, 2);
    $config{$key} = $value if defined $key and defined $value;
}

close $config_fh;

# Extract the configuration values.
my $log_file = $config{'log_file'} // die("log_file not found in config");
my $message_pattern = $config{'message_pattern'} // die("message_pattern not found in config");
my $lines_to_capture = $config{'lines_to_capture'} // die("lines_to_capture not found in config");
my $pattern_to_check = $config{'pattern_to_check'} // '';
my $output_file = $config{'output_file'} // die("output_file not found in config");

my $inside_section = 0;
my @section = ();

open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";
open my $output_fh, '>', $output_file or die "Could not open $output_file: $!";

while (my $line = <$log_fh>) {
    if ($line =~ /$message_pattern/) {
        $inside_section = 1;
        @section = ();
    }

    if ($inside_section) {
        push @section, $line;

        if (@section == $lines_to_capture && grep {/\b${pattern_to_check}\b/} @section) {
            foreach my $output_line (@section) {
                print $output_fh $output_line;
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