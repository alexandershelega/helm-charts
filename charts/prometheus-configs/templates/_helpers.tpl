
{{/*
Expand the name of the chart.
*/}}
{{- define "general.name" -}}
{{- default .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "general.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "general.labels" -}}
helm.sh/chart: {{ include "general.chart" . }}
{{ include "general.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "general.selectorLabels" -}}
app.kubernetes.io/name: {{ include "general.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

   

