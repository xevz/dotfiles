#!/usr/bin/env perl

use strict;
use warnings;

use AnyEvent::I3 qw(:all);

my $i3 = i3();

$i3->connect->recv;

$i3->subscribe({
        window => sub {
            my $e = shift;

            return unless $e->{container}->{layout};

            if ($e->{container}->{layout} eq 'splith') {
                $i3->message(TYPE_COMMAND, 'split v');
            }
        }
    })->recv;

AE::cv->recv;

