#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/QUEUE/QUEUE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Table::QUEUE;
use Try::Tiny;
use Exc::Exception;

my $s = Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");
Table::QUEUE->enqueue('peter', "xx");
$s = Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");
my $t = Table::QUEUE->dequeue('peter');
$s = Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");

do {
   try {
      my $pkt = "CCCCCC";
      Table::QUEUE->enqueue('peter', $pkt);
      my $ret=Table::QUEUE->dequeue('peter');
      print ($ret, "\n");

      $pkt = "DDDD";
      Table::QUEUE->enqueue('peter', $pkt);
      $ret=Table::QUEUE->dequeue('peter');
      print ($ret, "\n");

      $pkt = "EEEE";
      Table::QUEUE->enqueue('paul', $pkt);
      $ret=Table::QUEUE->dequeue('paul');

      print ($ret, "\n");
   }

   catch {
      my $cew_e = $_;
      if (ref($cew_e) ~~ "Exc::Exception") {
         my $exc_name = $cew_e->get_name();
         print("FATAL ERROR: $exc_name \n");
      } else {
         die("ref($cew_e)");
      }
   }
}

