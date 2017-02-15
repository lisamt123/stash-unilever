        #liveAgentClientChat.liveAgentStateWaiting {
        // The CSS class that is applied when the chat request is waiting to be accepted
        
        }
        #liveAgentClientChat {
        // The CSS class that is applied when the chat is currently engaged
        top: 0px;
        left: 0;
        right: 0;
        bottom: 0;
        position: absolute;
        }
        #liveAgentClientChat.liveAgentStateEnded {
        // The CSS class that is applied when the chat has ended
        
        }
        body { overflow: hidden; width: 100%; height: 100%; padding: 0; margin: 0 }
        #waitingMessage { height: 100%; width: 100%; vertical-align: middle; text-align: center;
        display: none; }
        #liveAgentClientChat.liveAgentStateWaiting #waitingMessage { display: table; }
        #liveAgentSaveButtonXXX, #liveAgentEndButtonXXX { z-index: 2; }
        .liveAgentChatInput {
        height: 25px;
        border-width: 1px;
        border-style: solid;
        border-color: #000;
        padding: 2px 0 2px 4px;
        background: #fff;
        display: block;
        width: 99%;
        }
        .liveAgentSendButton {
        display: block;
        width: 60px;
        height: 31px;
        padding: 0 0 3px;
        position: absolute;
        top: 0;
        right: -67px;
        }
        #liveAgentChatLog {
        width: auto;
        height: auto;
        top: 0px;
        position: absolute;
        overflow-y: auto;
        left: 0;
        right: 0;
        bottom: 0;
        }