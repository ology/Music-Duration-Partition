package Music::Duration::Partition;

# ABSTRACT: Partition a musical duration

our $VERSION = '0.0100';

use Moo;
use strictures 2;

use MIDI::Simple;
use List::Util qw/ min /;

use namespace::clean;

=head1 SYNOPSIS

  use MIDI::Util;

  my $score = MIDI::Util::setup_score();

  use Music::Duration::Partition;

  my $mdp = Music::Duration::Partition->new(
    size => 8,
    pool => [qw/ qn en sn /],
  );

  my $motif = $mdp->motif;

  my $notes = get_notes($motif); # Your imaginary note generator

  for my $n ( 0 .. @$notes - 1 ) {
    $score->n( $motif->[$n], $notes->[$n] );
  }

  $score->write_score('motif.mid');

=head1 DESCRIPTION

C<Music::Duration::Partition> partitions a musical duration into
smaller durations that equal the original given duration.

=head1 ATTRIBUTES

=head2 names

  $names = $mdp->names;

A hash reference of C<%MIDI::Simple::Length> (keyed by duration name).

Default: C<%MIDI::Simple::Length>

=cut

has names => (
    is      => 'ro',
    default => sub {
        return \%MIDI::Simple::Length;
    },
);

=head2 sizes

  $sizes = $mdp->sizes;

A hash reference of C<%MIDI::Simple::Length> (keyed by duration value).

Default: C<reverse %MIDI::Simple::Length>

=cut

has sizes => (
    is      => 'ro',
    default => sub {
        return { reverse %MIDI::Simple::Length };
    },
);

=head2 size

  $size = $mdp->size;

L<MIDI::Simple::Length> value for the duration of a whole note.

Default: C<4>

=cut

has size => (
    is      => 'ro',
    default => sub { return 4 },
);

=head2 pool

  $pool = $mdp->pool;

The list of possible note duration names to use in constructing a
motif.

Default: C<[ keys %MIDI::Simple::Length ]>

=cut

has pool => (
    is      => 'ro',
    default => sub { return [ keys %MIDI::Simple::Length ] },
);

=head2 threshold

  $threshold = $mdp->threshold;

The B<size> minus the smallest B<pool> duration value.

This is a computed attribute.

=cut

has threshold => (
    is       => 'ro',
    builder  => 1,
    lazy     => 1,
    init_arg => undef,
);

sub _build_threshold {
    my ($self) = @_;

    my @sizes = map { $self->duration($_) } @{ $self->pool };

    return ( $self->size - min(@sizes) ) - ( $self->size - 1 );
}

=head1 METHODS

=head2 new

  $mdp = Music::Duration::Partition->new(%arguments);

Create a new C<Music::Duration::Partition> object.

=head2 name

  $name = $mdp->name($duration);

Return the duration name of the given value.

=cut

sub name {
    my ( $self, $size ) = @_;
    return $self->sizes->{$size};
}

=head2 duration

  $duration = $mdp->duration($name);

Return the duration value of the given name.

=cut

sub duration {
    my ( $self, $name ) = @_;
    return $self->names->{$name};
}

=head2 motif

=cut

sub motif {
    my ($self) = @_;

    my $motif = [];

    my $sum = 0;

    while ( $sum < $self->size ) {
        my $name = $self->pool->[ int rand @{ $self->pool } ];
        my $size = $self->duration($name);
        my $diff = $self->size - $sum;
        next
            if $size > $diff;
        $sum += $size;
#warn(__PACKAGE__,' ',__LINE__," MARK: $name, $size, ",$sum,"\n");
        push @$motif, $name
            if $sum <= $self->size;
        last
            if $sum > $self->size - 1 + $self->threshold;
    }

    return $motif;
}

1;
__END__

=head1 SEE ALSO

The F<t/t/01-methods.t> and F<eg/motif> code in this distribution.

L<List::Util>

L<Moo>

L<MIDI::Simple>

=cut
