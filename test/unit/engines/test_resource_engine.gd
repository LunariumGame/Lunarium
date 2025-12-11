extends GutTest

func test_set():
	var rm = ResourceManager.new()
	rm.set_resource(ResourceManager.ResourceType.FOOD, 1234)
	assert_eq(rm.get_resource(ResourceManager.ResourceType.FOOD), 1234.0)
	rm.free()
