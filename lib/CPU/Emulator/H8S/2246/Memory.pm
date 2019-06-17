package CPU::Emulator::H8S::2246::Memory;
use Mojo::Base '-base';

use Mojo::ByteStream;

has bytes => sub { Mojo::ByteStream->new };

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246::Memory - Memory for the H8S/2246 CPU

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246::Memory;

  my $memory = CPU::Emulator::H8S::2246::Memory->new;

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246::Memory> implements memory for the H8S/2246 CPU.

=head1 ATTRIBUTES

L<CPU::Emulator::H8S::2246::Memory> implements the following attributes.

=head2 bytes

  my $bytes = $memory->bytes;
  $memory = $memory->bytes(Mojo::ByteStream->new);

Memory values, defaults to a L<Mojo::ByteStream> object.

=head1 METHODS

L<CPU::Emulator::H8S::2246::Memory> inherits all methods from L<Mojo::Base>.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
