package Fsm::CAR;

#================================================================--
# File Name    : Fsm/CAR.pm
#
# Purpose      : implements task CAR  (car detection)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant TRUE  => 1;
use constant FALSE => 0;

my $carTo;

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

   if ( $mmt_currentState ~~ "S0" ) {
      my $msg = $main::line->dequeue_packet();

      if ( defined($msg) ) {
         my @fields = split( " ", $msg );
         if (  ( defined( $fields[0] ) )
            && ( $fields[0] eq "CONTROL" )
            && ( defined( $fields[1] ) ) )
         {

            Table::TASK->reset("CARTO");

            if ( $fields[1] eq "CARON" ) {
               Table::SVAR->assign( "sv_car", 1 );
            }
            elsif ( $fields[1] eq "CAROFF" ) {
               Table::SVAR->assign( "sv_car", 0 );
            }
         }
      }
      return ( "S1" );
   }

   if ( $mmt_currentState ~~ "S1" ) {
      $carTo = Table::SVAR->get_value("sv_carTo");

      if ($carTo) {
         Table::SVAR->assign( "sv_car", 1 );
         Table::TASK->reset("CARTO");
      }

      Table::TASK->suspend("CAR");
      return ( "S0" );
   }

}

sub reset {
   my $self = shift @_;

   Table::TASK->reset("CARTO");
   return ("S0");
}

1;
