#================================================================--
# File Name    : Fsm/Verification/LTO/tb.cew
#
# Purpose      : unit testing
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#================================================================--

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Exc::Exception;
use Try::Tiny;
use Fsm::LTO;
use Executive::SCHEDULER;
use Executive::EXECUTIONER;
use Executive::TIMER;
use constant TRUE  => 1;
use constant FALSE => 0;
use Table::SVAR;
use Table::TASK;

sub clock_tick {
   my $num = shift @_;

   my $i;

   for ( $i = 0 ; $i < $num ; $i++ ) {
      Executive::SCHEDULER->tick();
      Executive::EXECUTIONER->tick();
   }
}

my $tl = Exc::TryCatch->new(
   fn => sub {

      Table::TASK->create(
         name     => "LTO",
         periodic => FALSE,
         run      => TRUE,
         resetPtr => Fsm::LTO->get_reset_ref(),
         taskPtr  => Fsm::LTO->get_task_ref()
      );

   }
);

$tl->run();
Table::SVAR->add( name => "sv_lto", value => 0 );

my $cew_Test_Count  = 0;
my $cew_Error_Count = 0;
no warnings "experimental::smartmatch";

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      clock_tick(1);
      my $xact = Table::TASK->get_currentState("LTO");
      my $xexp = "S0";
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 64, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 64, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      clock_tick(1);
      my $xact = Table::TASK->get_currentState("LTO");
      my $xexp = "S1";
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 65, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 65, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

clock_tick(8);
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      clock_tick(1);
      my $xact = Table::TASK->get_currentState("LTO");
      my $xexp = "S2";
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 67, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 67, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      clock_tick(1);
      my $xact = Table::TASK->get_currentState("LTO");
      my $xexp = "S3";
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 68, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 68, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      ;
      my $xact = Table::SVAR->get_value("sv_lto");
      my $xexp = 1;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 69, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 69, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

Table::TASK->reset("LTO");
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      clock_tick(1);
      my $xact = Table::TASK->get_currentState("LTO");
      my $xexp = "S0";
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 72, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 72, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

clock_tick(1);
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      ;
      my $xact = Table::SVAR->get_value("sv_lto");
      my $xexp = 0;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 74, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 74, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

print("\n**********Summary**********\n");
print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

