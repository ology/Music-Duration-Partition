#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use MIDI::Simple;

use_ok 'Music::Duration::Partition';

my $mdp = Music::Duration::Partition->new;
isa_ok $mdp, 'Music::Duration::Partition';

ok ref($mdp->names) eq 'HASH', 'names';
ok ref($mdp->sizes) eq 'HASH', 'sizes';
is $mdp->size, 4, 'size';
is_deeply $mdp->pool, [ keys %MIDI::Simple::Length ], 'pool';
is sprintf( '%.2f', $mdp->threshold ), 0.83, 'threshold';

is $mdp->name(4), 'wn', 'name';
is $mdp->duration('wn'), 4, 'duration';

$mdp = Music::Duration::Partition->new( pool => [qw/ wn /] );
isa_ok $mdp, 'Music::Duration::Partition';

is $mdp->threshold, -3, 'threshold';

my $got = $mdp->motif;
isa_ok $got, 'ARRAY';
is_deeply $got, ['wn'], 'motif';

$mdp = Music::Duration::Partition->new( size => 8, pool => [qw/ wn /] );
isa_ok $mdp, 'Music::Duration::Partition';

is $mdp->threshold, -3, 'threshold';

$got = $mdp->motif;
isa_ok $got, 'ARRAY';
is_deeply $got, [qw/ wn wn /], 'motif';

$mdp = Music::Duration::Partition->new( pool => [qw/ qn /] );
isa_ok $mdp, 'Music::Duration::Partition';

is $mdp->threshold, 0, 'threshold';

$got = $mdp->motif;
isa_ok $got, 'ARRAY';
is_deeply $got, [ ('qn') x 4 ], 'motif';

$mdp = Music::Duration::Partition->new( pool => [qw/ tqn /] );
isa_ok $mdp, 'Music::Duration::Partition';

is sprintf( '%.2f', $mdp->threshold ), 0.33, 'threshold';

$got = $mdp->motif;
isa_ok $got, 'ARRAY';
is_deeply $got, [ ('tqn') x 6 ], 'motif';
use Data::Dumper;warn(__PACKAGE__,' ',__LINE__," MARK: ",Dumper$got);

done_testing();
