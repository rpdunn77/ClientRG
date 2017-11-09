package Fsm::READ;

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

my $myport;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = { port => my $port };

   if ( defined( $params{port} ) ) {
      $self->{port} = $params{port};
      $myport = $self->{port};
   }
   else {
      die( Exc::Exception->new( port => "Task::CLIENT PORT undefined" ) );
   }

   bless( $self, $class );
   return $self;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   my $ns;

   if ( $mmt_currentState ~~ "READ" ) {
      my $msg = $main::line->dequeue_packet();
      if ( defined($msg) ) {
         my @fields = split( "_", $msg );
         if ( ( defined( $fields[0] ) ) && $fields[0] eq "RESET" ) {
            Table::TASK->reset("CLIENT");
         }
         elsif ( ( defined( $fields[1] ) ) && ( $fields[1] eq $myport ) ) {
            if ( ( defined( $fields[0] ) ) ) {
               if ( $fields[0] eq 'REGACK' ) {
                  Table::SVAR->assign( "sv_regack", 1 );
               }
               elsif ( $fields[0] eq 'ONDECK' ) {
                  Table::SVAR->assign( "sv_ondeck", 1 );
               }
               elsif ( $fields[0] eq 'GO' ) {
                  Table::SVAR->assign( "sv_go", 1 );
               }
            }

         }
      }

      Table::TASK->suspend("READ");
      return ( "READ" );
   }

}

sub reset {
   my $self = shift @_;

   return ("READ");
}

1;
