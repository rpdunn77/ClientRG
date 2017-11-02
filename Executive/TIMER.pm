package Executive::TIMER;
#================================================================--
# File Name    : Executive/TIMER.pm
#
# Purpose      : timer
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
#no warnings "experimental::smartmatch";

use Time::HiRes qw (ualarm);

my $sec=1.0;

sub set_period {
   my $self = shift @_;
   $sec = shift @_;
}

# signal alarm in 2.5s & every .1s thereafter
#   ualarm(2_500_000, 100_000);

sub start {
   my $self = shift @_;

   my $usec = int($sec * 1000000);
   print("usec $usec \n");

   ualarm(1000_000, $usec);
}

#convert seconds to ticks
sub s2t {
   my $self = shift @_;
   my $s = shift @_;

   return int($s / $sec)
}

1;
