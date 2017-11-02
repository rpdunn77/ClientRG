package Fsm::LIGHT;

#================================================================--
# File Name    : Fsm/LIGHT.pm
#
# Purpose      : implements task LIGHT (light selection)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = {};

   bless( $self, $class );
   return $self;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   my $ns;

   if ( $mmt_currentState ~~ "HG" ) {
      $main::line->enqueue_packet("LIGHT HG");
      my $car = Table::SVAR->get_value("sv_car");
      my $lto = Table::SVAR->get_value("sv_lto");
      my $sto = Table::SVAR->get_value("sv_sto");
      if ( !( $car && $lto ) ) {
         $ns = "HG";
      }
      else {
         $ns = "HY";
         Table::TASK->reset("STO");
         Table::TASK->reset("LTO");
      }

      Table::TASK->suspend("LIGHT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "HY" ) {
      $main::line->enqueue_packet("LIGHT HY");
      my $car = Table::SVAR->get_value("sv_car");
      my $lto = Table::SVAR->get_value("sv_lto");
      my $sto = Table::SVAR->get_value("sv_sto");
      if ( !$sto ) {
         $ns = "HY";
      }
      else {
         $ns = "FG";
         Table::TASK->reset("STO");
         Table::TASK->reset("LTO");
      }

      Table::TASK->suspend("LIGHT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "FG" ) {
      $main::line->enqueue_packet("LIGHT FG");
      my $car = Table::SVAR->get_value("sv_car");
      my $lto = Table::SVAR->get_value("sv_lto");
      my $sto = Table::SVAR->get_value("sv_sto");
      if ( ( $car || ( !$sto ) ) && ( !$lto ) ) {
         $ns = "FG";
      }
      else {
         $ns = "FY";
         Table::TASK->reset("STO");
         Table::TASK->reset("LTO");
      }

      Table::TASK->suspend("LIGHT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "FY" ) {
      $main::line->enqueue_packet("LIGHT FY");
      my $car = Table::SVAR->get_value("sv_car");
      my $lto = Table::SVAR->get_value("sv_lto");
      my $sto = Table::SVAR->get_value("sv_sto");
      if ( !$sto ) {
         $ns = "FY";
      }
      else {
         $ns = "HG";
         Table::TASK->reset("STO");
         Table::TASK->reset("LTO");
      }

      Table::TASK->suspend("LIGHT");
      return ( $ns );
   }

}

sub reset {
   my $self = shift @_;

   return ("HG");
}

1;
