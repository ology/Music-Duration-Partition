<div class="text-center">
  <h2 class="display-1">Description</h2>
  <p class="lead">Music::Duration::Partition is a Perl module that partitions a musical duration into randomized rhythmic phrases.</p>
  <p class="pt-5">
    <img alt="GitHub Issues" src="https://img.shields.io/github/issues/ology/Music-Duration-Partition" title="GitHub Issues">
  </p>
</div>

----

<div class="text-center">
  <h2 class="display-1">Features of the Module</h2>
  <h3>Durations</h3>
  <p>MIDI-Perl length pool aliases, 'hn' = half-note, 'qn' = quarter-note, 'ten' = triplet eighth note, etc.</p>
  <p>Fine-grained duration control specification with 'd' . number of "ticks." And there are 96 ticks per quarter-note, by default.</p>
  <h3>Motif Generation</h3>
  <p>Create single or multiple rhythmic phrases ("motifs").</p>
  <h3>Score Interaction</h3>
  <p>Add a motif and corresponding voices to a score.</p>
</div>

----

<h2 class="display-1 text-center pb-3">Quick Example</h2>

<div class="row">
  <div class="col-lg-6">
    <h3>Basic Usage</h3>
    <pre><code>use MIDI::Util qw(setup_score);
use Music::Duration::Partition ();
use Music::Scales qw(get_scale_MIDI);

my $score = setup_score();

my $mdp = Music::Duration::Partition->new(
    pool => [qw(hn dqn qn en)],
);

my $motif = $mdp->motif;

my @pitches = get_scale_MIDI('C', 4, 'major');

$mdp->add_to_score($score, $motif, \@pitches);

$score->write_score('duration-partition.mid');</code></pre>
  </div>
</div>

----

<div class="row">
  <div class="col-12 col-lg-6">
    <p><a class="btn btn-primary btn-lg" href="https://metacpan.org/dist/Music-Duration-Partition"><i class="fa-solid fa-download"></i> View on the CPAN</a></p>
  </div>
  <div class="col-12 col-lg-6">
    <h3>Music-Duration-Partition is available for Mac, Windows, Linux, and BSD distributions through the CPAN.</h3>
  </div>
</div>

----

<div class="text-center w-lg-75 w-xl-50 mx-auto">
  <p style="font-size:2rem">Powered by <a class="text-decoration:none" href="http://www.perl.org/">Perl</a></p>
  <h2 class="h4">What is Perl?</h2>
  <p>Perl is a high-level, general-purpose, interpreted, dynamic programming language and was developed by Larry Wall in 1987 as a Unix scripting language to make report processing easier. Since then, Perl has undergone many changes, revisions and is still in active development!</p>
  <p>Built with <a class="text-decoration:none" href="https://metacpan.org/dist/Web-PerlDistSite">Web::PerlDistSite</a></p>
</div>

