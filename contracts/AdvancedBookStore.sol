// // SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.8.2;

// import "./BookStore.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract AdvancedBookStore is BookStore {
//     mapping(uint256 => bool) public bestsellers;

//     event BookRemoved(uint256 indexed  bookId);
//     event BookMarkedAsBestseller(uint256 indexed  bookId);

//     constructor(address _owner) BookStore(_owner) {}


//     // mark book as a bestseller
//     function markAsBestseller(uint256 _bookId) public onlyOwner {
//         require(books[_bookId].price != 0, "Book does not exist.");
//         bestsellers[_bookId] = true;
//         emit BookMarkedAsBestseller(_bookId);
//     }
// // isAdmin, isAuth, isUser - true or false
//     function isBestseller(uint256 _bookId) public view returns (bool) {
//         return bestsellers[_bookId];
//     }

//     // Function to remove a book from the store
//     function removeBook(uint256 _bookId) public onlyOwner {
//         require(books[_bookId].price != 0, "Book does not exist.");
//         delete books[_bookId];

//         for (uint256 i = 0; i < bookIds.length; i++) {
//             if (bookIds[i] == _bookId) {
//                 bookIds[i] = bookIds[bookIds.length - 1];
//                 bookIds.pop(); // array remove
//                 break;
//             }
//         }

//         if (bestsellers[_bookId]) {
//             delete bestsellers[_bookId]; // Remove from bestsellers if applicable
//         }

//         emit BookRemoved(_bookId);
//     }

// }