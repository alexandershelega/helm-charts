
{{/*
Expand the name of the chart.
*/}}
{{- define "single.name" -}}
{{- default .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "single.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "single.labels" -}}
helm.sh/chart: {{ include "single.chart" . }}
{{ include "single.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "single.selectorLabels" -}}
app.kubernetes.io/name: {{ include "single.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

   
