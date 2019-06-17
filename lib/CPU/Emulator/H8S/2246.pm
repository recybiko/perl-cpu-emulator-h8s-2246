package CPU::Emulator::H8S::2246;
use Mojo::Base '-base';

use CPU::Emulator::H8S::2246::Register::General;

use Mojo::Collection 'c';

has registers => sub {c(
  map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
)};

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246 - CPU emulator for the H8S/2246

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246;

  my $cpu = CPU::Emulator::H8S::2246->new;

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246> is an interpreting emulator for the H8S/2246 CPU,
as found in the Cybiko Classic.

=head1 ATTRIBUTES

L<CPU::Emulator::H8S::2246> implements the following attributes.

=head2 registers

  my $collection = $cpu->registers;
  $cpu = $cpu->registers(c(
    map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
  ));

General registers, defaults to a L<Mojo::Collection> of 8
L<CPU::Emulator::H8S::2246::Register::General> objects.

=head1 METHODS

L<CPU::Emulator::H8S::2246> inherits all methods from L<Mojo::Base>.

=head1 SEE ALSO

L<Mojolicious>.

=cut
