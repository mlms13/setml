open Belt;

/* https://github.com/mui-org/material-ui/blob/master/docs/src/pages/demos/snackbars/ConsecutiveSnackbars.js */

type action =
  | Process
  | Close;

type messageInfo = {
  message: string,
  key: float,
};

type state = {
  open_: bool,
  msgInfo: option(messageInfo),
  messages: list(messageInfo),
};

let pushMsg = (messages, msg) => messages @ [{message: msg, key: Js.Date.now()}];

let pushMsgs = (messages, msgs) => messages @ List.map(msgs, msg => {message: msg, key: Js.Date.now()});

let popMsg = messages =>
  switch (messages) {
  | [] => (None, [])
  | [hd, ...tl] => (Some(hd), tl)
  };

let handleClose = (evt, reason, self) =>
  if (reason != "clickaway") {
    self.ReasonReact.send(Close);
  };

let handleExit = (evt, self) => self.ReasonReact.send(Process);

let component = ReasonReact.reducerComponent("ConsecutiveSnackbars");

let make = (_children, ~messages) => {
  ...component,
  reducer: (action, state) =>
    switch (action) {
    | Process =>
      let (maybeMsgInfo, messages) = popMsg(state.messages);
      switch (maybeMsgInfo) {
      | Some(_) as msgInfo => ReasonReact.Update({open_: true, msgInfo, messages})
      | None => ReasonReact.NoUpdate
      };
    | Close => ReasonReact.Update({...state, open_: false})
    },
  initialState: () => {open_: false, msgInfo: None, messages: []},
  willReceiveProps: self => {
    let open_ =
      if (List.length(messages) > 0) {
        false;
      } else {
        self.state.open_;
      };
    let msgs = pushMsgs(self.state.messages, messages);
    {...self.state, open_, messages: msgs};
  },
  didUpdate: ({oldSelf, newSelf}) => {
    newSelf.send(Process);
    ();
  },
  render: self =>
    switch (self.state.msgInfo) {
    | Some(msgInfo) =>
      let close = (evt, reason) => handleClose(evt, reason, self);
      let click = evt => handleClose(evt, "click", self);
      let exit = evt => handleExit(evt, self);
      let key = string_of_float(msgInfo.key);
      let msgEl = <span> (ReasonReact.string(msgInfo.message)) </span>;
      let actionEl =
        <span>
          <MaterialUi.IconButton key="close" color=`Inherit onClick=click>
            <MaterialUi.Icon> (ReasonReact.string("close")) </MaterialUi.Icon>
          </MaterialUi.IconButton>
        </span>;
      <MaterialUi.Snackbar
        key
        open_=self.state.open_
        message=msgEl
        autoHideDuration=(`Int(6000))
        onClose=close
        onExit=exit
        action=actionEl
      />;

    | None => ReasonReact.null
    },
};
