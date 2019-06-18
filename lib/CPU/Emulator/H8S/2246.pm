package CPU::Emulator::H8S::2246;
use Mojo::Base '-base';

use CPU::Emulator::H8S::2246::Memory;
use CPU::Emulator::H8S::2246::Register::ConditionCode;
use CPU::Emulator::H8S::2246::Register::General;

use Carp 'croak';
use Mojo::Collection 'c';
use Mojo::Util 'monkey_patch';

no warnings 'portable';

has instruction_address => 0;
has reset_address => 0;

has ccr => sub { CPU::Emulator::H8S::2246::Register::ConditionCode->new };
has memory => sub { CPU::Emulator::H8S::2246::Memory->new };

has registers => sub {c(
  map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
)};

foreach my $name (qw[
  add_b_rs_rd
  add_b_xx8_rd
  add_l_ers_erd
  add_l_xx32_erd
  add_w_rs_rd
  add_w_xx16_rd
  adds_l_1_erd
  adds_l_2_erd
  adds_l_4_erd
]) {
  monkey_patch __PACKAGE__, "_op_$name", sub {
    croak "STUB: $name";
  };
}

sub reset {
  my $self = shift;

  my $address = $self->memory->read32($self->reset_address);
  $self->instruction_address($address);

  return $self;
}

sub step {
  my $self = shift;

  state $handler_for = &_handlers;

  my $bytes = $self->_instruction;
  my $handlers = $handler_for->map(sub {
    my $masked_value = $bytes & $_->{mask};
    my $handler = $_->{handler_for}{$masked_value};
    return $handler // ();
  });
  die 'No handler found' unless $handlers->size;
  die 'Matched multiple handlers' if $handlers->size > 1;
  $handlers->first->($self, $bytes);

  return $self;
}

sub _handlers {
  my $self = shift;

  return c({
    mask => 0xF000_0000_0000_0000,
    handler_for => {
      0x8000_0000_0000_0000 => \&_op_add_b_xx8_rd,
    },
  }, {
    mask => 0xFF00_0000_0000_0000,
    handler_for => {
      0x0800_0000_0000_0000 => \&_op_add_b_rs_rd,
      0x0900_0000_0000_0000 => \&_op_add_w_rs_rd,
    },
  }, {
    mask => 0xFF88_0000_0000_0000,
    handler_for => {
      0x0A80_0000_0000_0000 => \&_op_add_l_ers_erd,
    },
  }, {
    mask => 0xFFF0_0000_0000_0000,
    handler_for => {
      0x7910_0000_0000_0000 => \&_op_add_w_xx16_rd,
    },
  }, {
    mask => 0xFFF8_0000_0000_0000,
    handler_for => {
      0x0B00_0000_0000_0000 => \&_op_adds_l_1_erd,
      0x0B80_0000_0000_0000 => \&_op_adds_l_2_erd,
      0x0B90_0000_0000_0000 => \&_op_adds_l_4_erd,
      0x7A10_0000_0000_0000 => \&_op_add_l_xx32_erd,
    },
  });
}

sub _instruction {
  my $self = shift;

  my $bytes = $self->memory->read64($self->instruction_address);
  return $bytes if defined $bytes;

  die 'Unable to fetch instruction';
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

=head2 step

  $cpu = $cpu->step;

Fetches and processes the next instruction.

=head1 SEE ALSO

L<Mojolicious>.

=cut
