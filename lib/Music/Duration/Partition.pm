package Music::Duration::Partition;

# ABSTRACT: Partition a musical duration

our $VERSION = '0.0308';

use Moo;
use strictures 2;

use MIDI::Simple;
use List::Util qw/ min /;

use namespace::clean;

=head1 SYNOPSIS

  use MIDI::Simple;
  use Music::Duration::Partition;
  use Music::Scales;

  my $mdp = Music::Duration::Partition->new(
    size => 8,
    pool => [qw/ qn en sn /],
  );

  $mdp->pool_code( sub { ... } ); # Optional

  my $motif = $mdp->motif;

  my @scale = get_scale_MIDI('C', 4, 'major');

  my $score = MIDI::Simple->new_score();

  for my $n ( 0 .. 31 ) { # 4 loops over the motif
    $score->n( $motif->[$n % @$motif], $scale[int rand @scale] );
  }

  $score->write_score('motif.mid');

=head1 DESCRIPTION

C<Music::Duration::Partition> partitions a musical duration, given by
the B<size>, into smaller durations drawn from the B<pool> of possible
durations.

=head1 ATTRIBUTES

=head2 names

  $names = $mdp->names;

A hash reference of C<%MIDI::Simple::Length> (keyed by duration name).

Default: C<%MIDI::Simple::Length>

=cut

has names => (
    is      => 'ro',
    default => sub { return \%MIDI::Simple::Length },
);

=head2 size

  $size = $mdp->size;

The value of the duration to partition.

Default: C<4> (4 quarter notes = 1 whole note)

=cut

has size => (
    is      => 'ro',
    default => sub { return 4 },
);

=head2 pool

  $pool = $mdp->pool;

The list of possible note duration names to use in constructing a
motif.

Default: C<[ keys %MIDI::Simple::Length ]> (wn, hn, qn, ...)

=cut

has pool => (
    is      => 'ro',
    isa     => sub { die 'Empty pool not allowed' unless ref( $_[0] ) eq 'ARRAY' && @{ $_[0] } > 0 },
    default => sub { return [ keys %MIDI::Simple::Length ] },
);

=head2 pool_code

  $name = $mdp->pool_code->();
  $mdp->pool_code( sub { ... } );

A code reference used to select an item from the given duration
B<pool>.

Default: Random item of B<pool>

=cut

has pool_code => (
    is      => 'rw',
    builder => 1,
    lazy    => 1,
);

sub _build_pool_code {
    my ($self) = @_;
    return sub { return $self->pool->[ int rand @{ $self->pool } ] };
};

=head2 min_size

  $min_size = $mdp->min_size;

Smallest B<pool> duration.  This is a computed attribute.

=cut

has min_size => (
    is       => 'ro',
    builder  => 1,
    lazy     => 1,
    init_arg => undef,
);

sub _build_min_size {
    my ($self) = @_;

    my @sizes = map { $self->_duration($_) } @{ $self->pool };

    return min(@sizes);
}

=head2 verbose

  $verbose = $mdp->verbose;

Show the progress of the B<motif> method.

=cut

has verbose => (
    is      => 'ro',
    default => sub { return 0 },
);

=head1 METHODS

=head2 new

  $mdp = Music::Duration::Partition->new(%arguments);

Create a new C<Music::Duration::Partition> object.

=head2 motif

  $motif = $mdp->motif;

Generate a rhythmic phrase of the given B<size>.

This method returns a different rhythmic motif each time it is called.

The default B<pool_code> used constructs this by selecting a B<pool>
duration at random, that fits into the size remaining after each
application, in a loop until the B<size> is met.

=cut

sub motif {
    my ($self) = @_;

    my $motif = [];

    my $format = '%.4f';

    my $sum = 0;

    while ( $sum < $self->size ) {
        my $name = $self->pool_code->();
        my $size = $self->_duration($name);
        my $diff = $self->size - $sum;

        last
            if sprintf( $format, $diff ) < sprintf( $format, $self->min_size );

        next
            if sprintf( $format, $size ) > sprintf( $format, $diff );

        $sum += $size;

        warn(__PACKAGE__,' ',__LINE__," $name, $size, $sum\n")
            if $self->verbose;

        push @$motif, $name
            if $sum <= $self->size;
    }

    return $motif;
}

sub _duration {
    my ( $self, $name ) = @_;
    return $self->names->{$name};
}

1;
__END__

=head1 SEE ALSO

The F<t/01-methods.t> and F<eg/*> code in this distribution.

L<List::Util>

L<Moo>

L<MIDI::Simple>

=cut
