use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Memory;

my $memory = CPU::Emulator::H8S::2246::Memory->new;
isa_ok $memory, 'CPU::Emulator::H8S::2246::Memory';

done_testing;
