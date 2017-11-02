#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Task/task_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Record::Task;

my $x = Record::Task->new();
$x->set_period(0);
$x->set_periodic(1);
$x->set_currentState(2);
$x->set_elapsedTime(5);
$x->set_deadline(6);
$x->set_fsm(8);
$x->dump();

my $y = $x->get_deadline();
print("Deadline == $y \n");
