var React = require('react');
var ReactDOM = require('react-dom');

var Tile = React.createClass({
  render: function() {
    var stateClass = this.props.item.state.on ? 'tile-badge on' : 'tile-badge off'
    return (
      <div className="tile bg-darkBlue fg-white" onClick={this.handleClick}>
        <div className="tile-content iconic">
            <span className="tile-label">{this.props.item.name}</span>
            <span className={stateClass}></span>
            <span className="icon mif-lamp"></span>
        </div>
      </div>
    );
    //return <a href="#" className="objectItem" onClick={this.handleClick}><img src={img} /><br />{this.props.item.name}</a>;
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

var Tiles = React.createClass({
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
      <span>
        {this.state.objects.map(function(item){
          return <Tile key={item.id} item={item}/>
        })}
      </span>
    );
  }
});

ReactDOM.render(<Tiles />, document.getElementById('tile-container'));
