import DummyItems from "../src/dummyItems";

describe('DummyItems', function() {

    it('should return the first item', function () {
        expect(DummyItems.getFirstItem()).toBe('Item 1')
    });
})