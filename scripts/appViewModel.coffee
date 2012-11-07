define 'appViewModel', ['../lib/knockout-2.2.0','toastr'], (ko, toastr) ->

    window.fakeData = [{
        "title": "Wire the money to Panama",
        "isDone": true},
    {
        "title": "Get hair dye, beard trimmer, dark glasses and \"passport\"",
        "isDone": false},
    {
        "title": "Book taxi to airport",
        "isDone": false},
    {
        "title": "Arrange for someone to look after the cat",
        "isDone": false}]
        
    task = (dataItem) -> do (_title = ko.observable(dataItem.title), _isDone = ko.observable(dataItem.isDone)) ->
        title: _title
        isDone: _isDone

    appViewModel = -> do (_newTaskText = ko.observable(''), _tasks = ko.observableArray([])) ->
        # Data   
        newTaskText: _newTaskText
        tasks: _tasks
        incompleteTasks: ko.computed ->   
              _tasks().filter (task) -> !task.isDone() && !task._destroy 
            
        # Operations
        addTask: =>
            _tasks.push task {title: _newTaskText(), isDone: false}
            _newTaskText("", false)
            return
        removeTask: (task) => 
            _tasks.destroy(task)   
            return
        save: => 
            $.ajax "http://jsfiddle.net/echo/jsonp/", 
            data: {json: ko.toJSON(_tasks)}, 
            type: "POST", dataType: 'jsonp', 
            success: (result) => toastr.success result.json, 'Tasks saved!'
        
        # Load initial state from server, then populate @tasks
        load: => 
            #$.ajax "http://respondto.it/ko-coffee-todo",         
            $.ajax "http://jsfiddle.net/echo/jsonp/", 
            data: {json: ko.toJSON(window.fakeData)}, 
            type: "POST", dataType: 'jsonp',
            success: (data) => _tasks.push task(item) for item in $.parseJSON(data.json)
            return