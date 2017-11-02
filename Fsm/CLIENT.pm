package Fsm::CLIENT;

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
my $starttime;
my $elapsedtime;

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

   if ( $mmt_currentState ~~ "UNREG" ) {
      my $reg = Table::SVAR->get_value("sv_regbutton");
      if ( $reg == 1 ) {
         my $regmsg = "REG_" . $myport;
         $main::line->enqueue_packet($regmsg);
         $ns = "WAITREG";
      }
      else {
         $ns = "UNREG";
      }
      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITREG" ) {
      my $msg = $main::line->dequeue_packet();

      if ( defined($msg) ) {
         my @fields = split( "_", $msg );
         if (  ( defined( $fields[0] ) )
            && ( $fields[0] eq "REGACK" )
            && ( defined( $fields[1] ) )
            && ( $fields[1] eq $myport ) )
         {
            Plant::SYSTEM->set_lights( "red", "gray", "gray" );
            $ns = "WAITONDECK";
         }
         else {
            $ns = "WAITREG";
         }
      }
      else {
         $ns = "WAITREG";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITONDECK" ) {
      my $msg = $main::line->dequeue_packet();

      if ( defined($msg) ) {
         my @fields = split( "_", $msg );
         if (  ( defined( $fields[0] ) )
            && ( $fields[0] eq "ONDECK" )
            && ( defined( $fields[1] ) )
            && ( $fields[1] eq $myport ) )
         {
            Plant::SYSTEM->set_lights( "gray", "yellow", "gray" );
            $ns = "WAITGO";
         }
         else {
            $ns = "WAITONDECK";
         }
      }
      else {
         $ns = "WAITONDECK";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITGO" ) {
      my $msg = $main::line->dequeue_packet();

      if ( defined($msg) ) {
         my @fields = split( "_", $msg );
         if (  ( defined( $fields[0] ) )
            && ( $fields[0] eq "GO" )
            && ( defined( $fields[1] ) )
            && ( $fields[1] eq $myport ) )
         {
            Plant::SYSTEM->set_lights( "gray", "gray", "green" )
              ; #not sure if we should move this to the start of go (after the timer started)
            $ns = "GO";
         }
         else {
            $ns = "WAITREG";
         }
      }
      else {
         $ns = "WAITGO";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "GO" ) {
      if ( !( defined($starttime) ) ) {
         $starttime = time();
      }
      my $stop = Table::SVAR->get_value("sv_stopbutton");
      if ( $stop == 1 ) {
         my $stoptime = time();
         $elapsedtime = $stoptime - $starttime;
         my $donemsg = "DONE_" . $myport . "_" . $elapsedtime;
         $main::line->enqueue_packet($donemsg);
         $ns = "STOP";
      }
      else {
         $ns = "GO";
      }
      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "STOP" ) {
      Plant::SYSTEM->set_lights( "gray", "gray", "gray" );
      $ns = "STOP";

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

}

sub reset {
   my $self = shift @_;

   return ("UNREG");
}

1;
