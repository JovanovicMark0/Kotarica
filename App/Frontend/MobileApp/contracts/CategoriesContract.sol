pragma solidity >=0.5.0;
contract CategoriesContract{
    uint public categoryCount = 0;

    struct CategoryInfo{
        uint id;
        string naziv;
    }

    mapping(uint => CategoryInfo) public categories;

    constructor() public {
        createCategory(categoryCount, "Alati");
        createCategory(categoryCount, "Automobili");
        createCategory(categoryCount, "Bela tehnika");
        createCategory(categoryCount, "Bicikli");
        createCategory(categoryCount, "Hrana");
        createCategory(categoryCount, "Dvoriste i basta");
        createCategory(categoryCount, "Elektronika i komponente");
        createCategory(categoryCount, "Industrijska oprema");
        createCategory(categoryCount, "Igracke i igre");
        createCategory(categoryCount, "Knjige");
        createCategory(categoryCount, "Kompjuteri");
        createCategory(categoryCount, "Laptovi");
        createCategory(categoryCount, "Konzole(PS,XBox,Nintendo)");
        createCategory(categoryCount, "Mobilni telefoni");
        createCategory(categoryCount, "Motocikli");
        createCategory(categoryCount, "Muzicki instrumenti");
        createCategory(categoryCount, "Nakit");
        createCategory(categoryCount, "Namestaj");
        createCategory(categoryCount, "Kozmeticki preparati");
        createCategory(categoryCount, "Nekretnine");
        createCategory(categoryCount, "Kolekcionarstvo");
        createCategory(categoryCount, "Obuca");
        createCategory(categoryCount, "Odeca");
        createCategory(categoryCount, "Putovanja");
        createCategory(categoryCount, "Kancelarijska oprema");
        createCategory(categoryCount, "Zdravstvena oprema");
        createCategory(categoryCount, "Poljoprivreda");
        createCategory(categoryCount, "Sport i razonoda");
        createCategory(categoryCount, "Skola");
        createCategory(categoryCount, "Modni dodaci");
        createCategory(categoryCount, "Transportna vozila");
        createCategory(categoryCount, "TV i video aparati");
        createCategory(categoryCount, "Uredjenje kuce");
        createCategory(categoryCount, "Zivotinje");
        createCategory(categoryCount, "Za mame");

        emit categoriesCreated("Kategorije su kreirane");
    }

    function createCategory(uint _id, string memory _naziv) public{
        categories[categoryCount++] = CategoryInfo(_id, _naziv);
    }

    event categoriesCreated(string naziv);

}