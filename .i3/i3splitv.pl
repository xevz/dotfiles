#!/usr/bin/env perl

=head1 SYNOPSIS

Start using

start-stop-daemon --start --make-pidfile --background --pidfile $HOME/.i3/splitv.pid --exec $HOME/.i3/i3splitv.pl

=cut

use strict;
use warnings;

use AnyEvent::I3 qw(:all);

my $i3 = i3();

$i3->connect->recv;

$i3->subscribe({
        window => sub {
            my $e = shift;

            return unless $e->{container}->{layout} ;

            if ($e->{container}->{layout} eq 'splith') {
                $i3->message(TYPE_COMMAND, 'split v');
            }
        }
    })->recv;

AE::cv->recv;

