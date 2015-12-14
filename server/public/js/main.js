var React = require('react');
var ReactDOM = require('react-dom');

var ObjectItem = React.createClass({
  render: function() {
    var img = this.props.item.state.on ? '/images/bulb-on.png' : '/images/bulb.png'
    return <a href="#" className="objectItem" onClick={this.handleClick}><img src={img} /><br />{this.props.item.name}</a>;
  },
  handleClick: function(event){
    newState = {on: !this.props.item.state.on}
    //$.post('/api/v1/object/'+this.props.item.id+'/desired/state', newState, 'json')
    $.ajax({
      type: "POST",
      url: '/api/v1/object/'+this.props.item.id+'/desired/state',
      data: JSON.stringify(newState),
      dataType: 'json',
      contentType: 'application/json; charset=utf-8'
    });
      //success: success,
  }
});

var UserGist = React.createClass({
  getInitialState: function() {
    return {objects:[]};
  },

  componentDidMount: function() {
    objects = [];
    setState = this.setState.bind(this);
    $.get('/api/v1/object/list', function(result) {
      console.log(result);
      if (this.isMounted()) {
        objects = result;
        setState({objects: objects});
      }
    }.bind(this));

    var source = new EventSource('api/v1/events');
    source.addEventListener('/object/state/changed', function(e) {
      newObj = JSON.parse(e.data);
      console.log('/object/state/changed',newObj);
      objects = objects.map(function(obj){
        if(obj.id == newObj.id){
          return newObj;
        }else{
          return obj;
        }
      });
      setState({objects: objects});
    }, false);
  },

  render: function() {
    return (
      <div className="objectItemList">
        {this.state.objects.map(function(item){
          return <ObjectItem key={item.id} item={item}/>
        })}
      </div>
    );
  }
});

ReactDOM.render(
  <UserGist source="https://api.github.com/users/octocat/gists" />,
  document.getElementById('example')
);
