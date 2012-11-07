define 'jquery', [], -> this.jquery
define 'toastr', [], -> this.toastr

require ['../lib/knockout-2.2.0', 'appViewModel'], (ko, appViewModel) -> 
	vm = appViewModel()
	vm.load()
	$ -> 
		ko.applyBindings vm
		return
	return