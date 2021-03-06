/*
Copyright 2018 FileThis, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/*
`ft-user-interactions-demo`
An element that defines the top-level of the FileThis user interactions demo application.

This application uses sample user interaction requests to show how they are rendered by the ft-user-interaction-form,
and to show what user interaction response data is generated when the user fills in the dialog and commits it.
*/
/*
  FIXME(polymer-modulizer): the above comments were extracted
  from HTML and may be out of place here. Review them and
  then delete this comment!
*/
import '@filethis/ft-user-interaction-form/ft-user-interaction-form.js';

import '@polymer/iron-flex-layout/iron-flex-layout-classes.js';
import '@polymer/paper-button/paper-button.js';
import '@polymer/paper-dropdown-menu/paper-dropdown-menu.js';
import '@polymer/paper-item/paper-item.js';
import '@polymer/paper-listbox/paper-listbox.js';
import '@polymer/paper-menu-button/paper-menu-button.js';
import '@polymer/polymer/polymer-legacy.js';
import '@filethis/juicy-ace-editor/juicy-ace-editor-module.js';
import { Polymer } from '@polymer/polymer/lib/legacy/polymer-fn.js';
import { html } from '@polymer/polymer/lib/utils/html-tag.js';
Polymer({
  _template: html`
        <style include="iron-flex iron-flex-alignment iron-positioning"></style>

        <style>
            :host {
                display: block;
                overflow: hidden;
                background-color: #FAFAFA;
                padding-left: 16px;
                padding-right: 16px;
                @apply --layout-vertical;
                @apply --layout-center;
                @apply --ft-user-interactions-demo;
            }
        </style>

        <!-- Header -->
        <div class="layout horizontal center">

            <iron-label style="font-family:Arial; padding-top: 17px">
                A demo of FileThis user interactions
            </iron-label>

            <!-- Spacer -->
            <div style="width:30px;"></div>

            <!-- Versions -->
            <paper-dropdown-menu label="Version" style="width:75px;" no-animations="true">
                <paper-listbox class="dropdown-content" slot="dropdown-content" selected="{{_selectedVersionIndex}}">
                    <template is="dom-repeat" items="[[_versions]]" as="version">
                        <paper-item>[[version]]</paper-item>
                    </template>
                </paper-listbox>
            </paper-dropdown-menu>

            <!-- Spacer -->
            <div style="width:30px;"></div>

            <!-- Requests -->
            <paper-dropdown-menu label="Example Request" style="width:250px;" no-animations="true">
                <paper-listbox class="dropdown-content" slot="dropdown-content" selected="{{_selectedRequestIndex}}">
                    <template is="dom-repeat" items="[[_requests]]" as="request">
                        <paper-item>[[_getRequestName(request)]]</paper-item>
                    </template>
                </paper-listbox>
            </paper-dropdown-menu>
        </div>

        <!-- Spacer -->
        <div style="height:30px;"></div>

        <!-- Content -->
        <div class="flex layout horizontal" style="width:100%; padding-bottom: 16px; ">

            <!-- Request -->
            <div class="flex layout vertical" style="min-width:250px; ">

                <!-- Heading -->
                <div class="layout horizontal center" style="padding-left:10px; padding-bottom: 10px; ">
                    <iron-label style="font-family:Arial;">
                        Request
                    </iron-label>
                </div>

                <!-- Text -->
                <juicy-ace-editor id="requestText" class="flex" style="border:1px solid #DDD; " readonly="" theme="ace/theme/eclipse" mode="ace/mode/json" fontsize="14px" softtabs="" tabsize="4" value="[[_requestText]]"></juicy-ace-editor>
            </div>

            <!-- Spacer -->
            <div style="width:20px; min-width:20px; "></div>

            <!-- Form -->
            <div class="layout vertical" style="width:400px;">

                <!-- Heading -->
                <div class="layout horizontal center" style="width:100%; padding-left: 10px; padding-bottom: 10px; ">
                    <iron-label style="font-family:Arial;">
                        Dialog generated from request
                    </iron-label>
                </div>

                <!-- Form -->
                <ft-user-interaction-form id="userInteractionForm" request="{{_selectedRequest}}" response="{{_response}}" on-entered-data-changed="_onEnteredDataChanged" style="background:white; border: 1px solid #DDD; ">
                </ft-user-interaction-form>
            </div>

            <!-- Spacer -->
            <div style="width:20px; min-width:20px; "></div>

            <!-- Response -->
            <div class="flex layout vertical" style="min-width:250px;">

                <!-- Heading -->
                <div class="layout horizontal center" style="padding-left:10px; padding-bottom: 10px; ">
                    <iron-label style="font-family:Arial;">
                        Response
                    </iron-label>
                </div>

                <!-- Text -->
                <juicy-ace-editor id="responseText" class="flex" hidden\$="[[!_response]]" style="border:1px solid #DDD; " readonly="" theme="ace/theme/eclipse" mode="ace/mode/json" fontsize="14px" softtabs="" tabsize="4" value="[[_responseText]]"></juicy-ace-editor>
                <div class="flex layout horizontal center center-justified" hidden\$="[[_response]]" style="color:#DDD;
                            background-color: white;
                            font-size: 14px;
                            font-family: Arial, Helvetica, sans-serif;
                            border: 1px solid #DDD;">
                    <div>
                        Fill in dialog to the left
                    </div>
                </div>
            </div>
        </div>
`,

  is: 'ft-user-interactions-demo',

  properties:
  {
      // Version ----------------------------

      _versions:
      {
          type: Array,
          notify: true,
          value: [
              '1.0.0',
              '2.0.0'
          ]
      },

      _selectedVersion:
      {
          type: String,
          notify: true,
          value: "1.0.0",
          observer: "_onSelectedVersionChanged"
      },

      _selectedVersionIndex:
      {
          type: Number,
          notify: true,
          value: "0",
          observer: "_onSelectedVersionIndexChanged"
      },


      // Request ----------------------------

      _requests:
      {
          type: Array,
          notify: true,
          value: [],
          observer: "_onRequestsChanged"
      },

      _requestText:
      {
          type: String,
          notify: true,
          value: "",
          observer: "_onRequestTextChanged"
      },

      _selectedRequest:
      {
          type: Object,
          notify: true,
          value: null,
          observer: "_onSelectedRequestChanged"
      },

      _selectedRequestIndex:
      {
          type: Number,
          notify: true,
          value: "1",
          observer: "_onSelectedRequestChangedIndexChanged"
      },

      // Response ----------------------------

      _response:
      {
          type: Object,  // JSON
          notify: true,
          value: null,
          observer: "_onResponseChanged"
      },

      _responseText:
      {
          type: String,
          notify: true,
          value: "",
          observer: "_onResponseTextChanged"
      }
  },

  ready: function()
  {
      // Suppress deprecation warning
      this.$.requestText.editor.$blockScrolling = Infinity;
      this.$.responseText.editor.$blockScrolling = Infinity;
  },

  _requestNames_1_0_0: [
      "branch-code",
      "credentials",
      "generic-choices",
      "generic-ota",
      "generic-text",
      "not-paperless",
      "not-supported",
      "pin",
      "us-state",
      "user-action-required",
      "user-locked-out",
      "user-must-set-up-account"
  ],

  _requestNames_2_0_0: [
      "alert",
      "branch-code",
      "credentials",
      "error",
      "general-choices",
      "general-ota",
      "general-text",
      "not-paperless",
      "not-supported",
      "pin",
      "retry-first",
      "retry-multiple",
      "us-state",
      "user-action-required",
      "user-locked-out",
      "user-must-set-up-account"
  ],

  _requestNamesToLoad: [],
  _loadedRequests: [],

  _loadAllRequests: function()
  {
      this._loadedRequests = [];

      switch (this._selectedVersion)
      {
          case "1.0.0":
              this._requestNamesToLoad = this._requestNames_1_0_0.slice();
              break;
          case "2.0.0":
              this._requestNamesToLoad = this._requestNames_2_0_0.slice();
              break;
          default:
              throw new Error("Unknown user interaction schema version: " + this._selectedVersion);
      }

      this._loadNextRequest();
  },

  _loadNextRequest: function()
  {
      var done = (this._requestNamesToLoad.length === 0);
      if (done)
      {
          this._requests = this._loadedRequests;
          return;
      }

      var name = this._requestNamesToLoad.shift();
      var url = "data/user-interaction-request-" + name + "-example-" + this._selectedVersion + ".json";

      var xmlHttpRequest = new XMLHttpRequest();
      xmlHttpRequest.overrideMimeType("application/json");
      xmlHttpRequest.open('GET', url, true);
      xmlHttpRequest.onreadystatechange = function()
      {
          if (xmlHttpRequest.readyState === 4 &&
              xmlHttpRequest.status === 200)
          {
              var requestAsJson = JSON.parse(xmlHttpRequest.responseText);
              this._loadedRequests.push(requestAsJson);

              this._loadNextRequest();
          }
      }.bind(this);
      xmlHttpRequest.send();
  },

  _getRequestName: function(request)
  {
      switch (this._selectedVersion)
      {
          case "1.0.0":
              return request.title;
          case "2.0.0":
              return request["2.0.0"].title;
          default:
              throw new Error("Unknown user interaction schema version: " + version);
      }
  },

  _onSelectedVersionChanged: function(to, from)
  {
      // Update the popup selection
      this._selectedVersionIndex = this._mapVersionToIndex(this._selectedVersion);

      // Update version used by the form
      this.$.userInteractionForm.version = this._selectedVersion;

      // Load examples for this version
      this._loadAllRequests();
  },

  _mapVersionToIndex: function(version)
  {
      switch (version)
      {
          case "1.0.0":
              return 0;
          case "2.0.0":
              return 1;
          default:
              throw new Error("Unknown user interaction schema version: " + version);
      }
  },

  _onSelectedVersionIndexChanged: function(to, from)
  {
      if (this._selectedVersionIndex === null)
      {
          this._selectedVersion = null;
          return;
      }

      switch (this._selectedVersionIndex)
      {
          case 0:
              this._selectedVersion = "1.0.0";
              break;
          case 1:
              this._selectedVersion = "2.0.0";
              break;
          default:
              throw new Error("Invalid version index: " + this._selectedVersionIndex.toString());
      }
  },

  _onSelectedRequestChanged: function(to, from)
  {
      this._updateRequestText();
      
      // Update the popup selection
      if (this._selectedRequest === null)
          this._selectedRequestIndex = null;
      else
          this._selectedRequestIndex = this._mapRequestToIndex(this._selectedRequest);
  },

  _mapRequestToIndex: function(request)
  {
      return this._requests.indexOf(request);
  },

  _onSelectedRequestChangedIndexChanged: function(to, from)
  {
      if (this._selectedRequestIndex === null)
      {
          this._selectedRequest = null;
          return;
      } 

      this._selectedRequest = this._requests[this._selectedRequestIndex];
  },

  _onRequestsChanged: function(to, from)
  {
      // Select the first reques
      if (this._requests.length > 0)
      {
          var firstRequest = this._requests[0];
          this._selectedRequest = firstRequest;
      }
  },

  _onResponseChanged: function(to, from)
  {
      this._updateResponseText();
  },

  _onRequestTextChanged: function(to, from)
  {
      this.$.requestText.editor.selection.selectFileStart();
  },

  _onResponseTextChanged: function(to, from)
  {
      this.$.responseText.editor.selection.selectFileStart();
  },

  _updateRequestText: function()
  {
      if (this._selectedRequest === null)
          this._requestText = "";
      else
          this._requestText = JSON.stringify(this._selectedRequest, null, 4);
  },

  _updateResponseText: function()
  {
      if (this._response === null)
          this._responseText = "";
      else
          this._responseText = JSON.stringify(this._response, null, 4);
  },

  _onEnteredDataChanged: function(event)
  {
      this.$.userInteractionForm.generateResponse();
  }
});
