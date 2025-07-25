
{{/*
Expand the name of the chart.
*/}}
{{- define "general.name" -}}
{{- .Values.name | default (printf "%s" .Chart.Name) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "general.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "general.validateValues" -}}
{{- if and .Values.deployment.enabled .Values.daemonset.enabled -}}
{{- fail "Both deployment and daemonset cannot be enabled simultaneously" -}}
{{- end -}}
{{- if and .Values.deployment.enabled .Values.cronjob.enabled -}}
{{- fail "Both deployment and cronjob cannot be enabled simultaneously" -}}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "general.labels" -}}
helm.sh/chart: {{ include "general.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "general.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


   

{{/*
Deployment Containers
*/}}
{{- define "general.deploymentContainers" -}}   
      {{- range $key, $val :=  .containerList }} 
      - name: {{ index $val.name }}
        image: {{ index $val.repository }}:{{ index $val.tag }}
        imagePullPolicy: {{ index $val.pullPolicy | default "IfNotPresent" }}
        ###### lifecycle
        {{- if index $val.lifecycle  }}
        lifecycle:
        {{- toYaml ( index $val.lifecycle ) | nindent 12 -}}
        {{- end }}    
        ##### container run command
        {{- if index $val.cmd  }}
        command:
        {{- toYaml ( index $val.cmd  )| nindent 12 }}
        {{- end }}
        {{- if index $val.arg  }}
        args:
        {{- toYaml ( index $val.arg )| nindent 12 }}
        {{- end }}     
        ##### container ports 
        ports:
        {{- range (index $val.containerPort ) }}
        - containerPort: {{ . }}
        {{- end }}            
        ##### resources                    
        {{- if index $val.resources  }}
        resources:
        {{- toYaml (index $val.resources ) | nindent 12 }}          
        {{- end }}  
        ##### readinessProbe probe
        {{- if index $val.readinessProbe  }}
        readinessProbe:
        {{- toYaml (index $val.readinessProbe ) | nindent 12 }}
        {{- end }}
        ##### livenessProbe probe
        {{- if index $val.livenessProbe  }}
        livenessProbe:
        {{- toYaml ( index $val.livenessProbe ) | nindent 12 }}
        {{- end }}      
        ##### startupProbe probe
        {{- if index $val.startupProbe  }}
        startupProbe:
        {{- toYaml ( index $val.startupProbe ) | nindent 14 }}
        {{- end }}                  
        ###### securityContext
        {{- if index $val.securityContext  }}          
        securityContext:
        {{- toYaml ( index $val.securityContext )| nindent 12 }}   
        {{- end }} 
        ###### volumeMounts     
        {{- if index $val.volumeMounts  }}                                                  
        volumeMounts:
          {{-  toYaml ( index $val.volumeMounts ) | nindent 12 }} 
        {{- end }}   
        ###### env block   
        {{- if index $val.env  }}                    
        env:
          - name: TERM
            value: "xterm"
        {{- range $key, $value := index $val.env }}
          - name: {{ $key }}
            value: {{ $value | quote }}
        {{- end }} 
        {{- end }}       
    {{- end }}               
{{- end }}


{{/*
Deployment Containers
*/}}
{{- define "general.cronjobContainers" -}}   
          {{- range $key, $val :=  .containerList }} 
          - name: {{ index $val.name }}
            image: {{ index $val.repository }}:{{ index $val.tag }}
            imagePullPolicy: {{ index $val.pullPolicy | default "IfNotPresent" }}
            ###### lifecycle
            {{- if index $val.lifecycle  }}
            lifecycle:
            {{- toYaml ( index $val.lifecycle ) | nindent 14 -}}
            {{- end }}    
            ##### container run command
            {{- if index $val.cmd  }}
            command:
            {{- toYaml ( index $val.cmd  )| nindent 14 }}
            {{- end }}
            {{- if index $val.arg  }}
            args:
            {{- toYaml ( index $val.arg )| nindent 14 }}
            {{- end }}     
            ##### container ports 
            ports:
            {{- range (index $val.containerPort ) }}
            - containerPort: {{ . }}
            {{- end }}            
            ##### resources                    
            {{- if index $val.resources  }}
            resources:
            {{- toYaml (index $val.resources ) | nindent 14 }}          
            {{- end }}  
            ##### readinessProbe probe
            {{- if index $val.readinessProbe  }}
            readinessProbe:
            {{- toYaml (index $val.readinessProbe ) | nindent 14 }}
            {{- end }}
            ##### livenessProbe probe
            {{- if index $val.livenessProbe  }}
            livenessProbe:
            {{- toYaml ( index $val.livenessProbe ) | nindent 14 }}
            {{- end }}      
            ##### startupProbe probe
            {{- if index $val.startupProbe  }}
            startupProbe:
            {{- toYaml ( index $val.startupProbe ) | nindent 14 }}
            {{- end }}                     
            ###### securityContext
            {{- if index $val.securityContext  }}          
            securityContext:
            {{- toYaml ( index $val.securityContext )| nindent 14 }}   
            {{- end }} 
            ###### volumeMounts     
            {{- if index $val.volumeMounts  }}                                                  
            volumeMounts:
              {{-  toYaml ( index $val.volumeMounts ) | nindent 14 }} 
            {{- end }}   
            ###### env block   
            {{- if index $val.env  }}                    
            env:
              - name: TERM
                value: "xterm"
            {{- range $key, $value := index $val.env }}
              - name: {{ $key }}
                value: {{ $value | quote }}
            {{- end }} 
            {{- end }}       
          {{- end }}  
{{- end }}