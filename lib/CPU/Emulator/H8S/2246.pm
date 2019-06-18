package CPU::Emulator::H8S::2246;
use Mojo::Base '-base';

use CPU::Emulator::H8S::2246::Memory;
use CPU::Emulator::H8S::2246::Register::ConditionCode;
use CPU::Emulator::H8S::2246::Register::General;

use Mojo::Collection 'c';

has instruction_address => 0;
has reset_address => 0;

has ccr => sub { CPU::Emulator::H8S::2246::Register::ConditionCode->new };
has memory => sub { CPU::Emulator::H8S::2246::Memory->new };

has registers => sub {c(
  map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
)};

sub reset {
  my $self = shift;

  my $address = $self->memory->read32($self->reset_address);
  $self->instruction_address($address);

  return $self;
}

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

=head2 ccr

  my $ccr = $cpu->ccr;
  $cpu = $cpu->ccr(CPU::Emulator::H8S::2246::Register::ConditionCode->new);

Condition Code Register for the CPU, defaults to a
L<CPU::Emulator::H8S::2246::Register::ConditionCode> object.

=head2 instruction_address

  my $address = $cpu->instruction_address;
  $cpu = $cpu->instruction_address(0);

The address of the next instruction, defaults to 0.

=head2 memory

  my $memory = $cpu->memory;
  $memory = $cpu->memory(CPU::Emulator::H8S::2246::Memory->new);

Memory for the CPU, defaults to a L<CPU::Emulator::H8S::2246::Memory> object.

=head2 registers

  my $collection = $cpu->registers;
  $cpu = $cpu->registers(c(
    map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
  ));

General registers, defaults to a L<Mojo::Collection> of 8
L<CPU::Emulator::H8S::2246::Register::General> objects.

=head2 reset_address

  my $address = $cpu->reset_address;
  $cpu = $cpu->reset_address(0);

The address of the address of the first instruction, defaults to 0.

=head1 METHODS

L<CPU::Emulator::H8S::2246> inherits all methods from L<Mojo::Base> and
implements the following new ones.

=head2 reset

  $cpu = $cpu->reset;

Resets the CPU by setting the C<instruction_address> to the address stored at
C<reset_address>.

=head1 SEE ALSO

L<Mojolicious>.

=cut
