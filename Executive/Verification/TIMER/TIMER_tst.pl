#!/usr/bin/perl
######################################################
# Peter Walsh
# TIMER test driver
######################################################

use lib '../../../';
use Executive::TIMER;
$SIG{ALRM} = sub {print("tick\n");};

Executive::TIMER->start(0.1);
my $c = Executive::TIMER->s2t(3);
print("Conv $c \n");

while (1) {
}
