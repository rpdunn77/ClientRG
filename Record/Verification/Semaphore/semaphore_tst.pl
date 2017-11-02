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
use Record::Semaphore;
use Record::Task;

my $x = Record::Task->new();
$x->set_blocked(0);
my $y = Record::Semaphore->new();

$x->dump();
$y->dump();
print("\n");

$y->wait($x);
$x->dump();
$y->dump();
print("\n");

$y->signal($x);
$x->dump();
$y->dump();
print("\n");
