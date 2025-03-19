#[derive(Copy, Drop, Serde, Hash)]
pub struct Person {
   name : felt252,
   age : u8,
}

#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    fn create(ref self: TContractState, id: u32, student: Person) -> bool;
    fn update(ref self: TContractState, id: u32, student: Person) -> bool;
    fn get_storage(self: @TContractState, id: u32) -> Person;
}

#[starknet::contract]
pub mod SimpleStorage {
    use super::Person;
    use core::starknet::storage::{Map, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry};

    #[storage]
    struct Storage {
        register_student: Map::<u32, Person>,
    }

    #[abi(embed_v0)]
    impl SimpleStorageImpl of super::ISimpleStorage<ContractState>  {
        fn create(ref self: ContractState, id: u32, student: Person) -> bool {
            self.register_student.entry(id).write(Person);
            return true;
        }

        fn update(ref self: ContractState, id: u32, student: Person) -> bool {
            let mut update_student = self.register_student.read(id);
            update_student.entry(id).write(Person);
            return true;
        }

        fn get_storage(self: @ContractState, id: u32) -> Person {
            self.register_student.read(id);
            return Person;
        }
    }

}