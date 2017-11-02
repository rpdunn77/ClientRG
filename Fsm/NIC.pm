package Fsm::NIC;

#================================================================--
# File Name    : Fsm/NIC.pm
#
# Purpose      : implements task NIC
#                (network interface controller)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant MAXLEN => 100;

my $soc = undef;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = { port => my $port };

   if ( defined( $params{port} ) ) {
      $self->{port} = $params{port};
   }
   else {
      die( Exc::Exception->new( port => "Task::NIC PORT undefined" ) );
   }

   bless( $self, $class );
   return $self;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   my $ns;
   my $nicTo;

   if ( $mmt_currentState ~~ "RW" ) {
      $nicTo = Table::SVAR->get_value("sv_nicTo");

      if ( !$nicTo ) {
         my $buff;

         $soc->read( $buff, MAXLEN );

         if ( ( defined($buff) ) && ( length($buff) != 0 ) ) {
            $main::line->enqueue_packet_fragment($buff);
            Table::TASK->reset("NICTO");
         }

         $buff = $main::line->dequeue_packet_fragment(MAXLEN);

         if ( defined($buff) ) {
            $soc->write($buff);
         }

         $ns = "RW";
      }
      else {
         $ns = "OPEN";
      }

      Table::TASK->suspend("NIC");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAIT" ) {
      $main::line->flush();

      $nicTo = Table::SVAR->get_value("sv_nicTo");

      if ($nicTo) {
         $ns = "OPEN";
      }
      else {
         $ns = "WAIT";
      }

      Table::TASK->suspend("NIC");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "OPEN" ) {
      undef($soc);

      print("Try to open socket\n");
      $soc = new IO::Socket::INET(
         PeerAddr => 'localhost',
         PeerPort => $self->{port},
         Proto    => 'tcp',
         Timeout  => 0.5,
         Blocking => 0
      );

      if ( !defined($soc) ) {
         print("Failed to open\n");
         $ns = "WAIT";
      }
      else {
         print("Open\n");
         $ns = "RW";
      }

      Table::TASK->suspend("NIC");
      Table::TASK->reset("NICTO");
      return ( $ns );
   }

}

sub reset {
   my $self = shift @_;

   Table::TASK->reset("NICTO");
   return ("OPEN");
}

1;
