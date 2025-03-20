 #[derive(Copy, Drop, Serde, starknet::Store)]
pub struct Person {
   name : felt252,
   age : u8,
}

#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    fn create(ref self: TContractState, name: felt252, student: Person);
    fn update(ref self: TContractState, name: felt252, student: Person);
    fn get_storage(self: @TContractState, name: felt252,) -> Person;
}

#[starknet::contract]
pub mod SimpleStorage {
    use super::Person;
    use core::starknet::storage::Map;
    use core::starknet::storage::StoragePathEntry;
    use core::starknet::storage::StoragePointerWriteAccess;
    use core::starknet::storage::StoragePointerReadAccess;

    #[storage]
    struct Storage {
        student_lib: Map<felt252, Person>,
    }

    #[abi(embed_v0)]
    impl SimpleStorageImpl of super::ISimpleStorage<ContractState>  {
        fn create(ref self: ContractState, name: felt252, student: Person){
            self.student_lib.entry(name).write(student);
        }

        fn update(ref self: ContractState, name: felt252, student: Person){
             self.student_lib.entry(name).write(student);
        }

        fn get_storage(self: @ContractState, name: felt252,) -> Person {
            self.student_lib.entry(name).read()
        }
    }
}
