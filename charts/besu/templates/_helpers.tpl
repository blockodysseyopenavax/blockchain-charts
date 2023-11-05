{{/*
Expand the name of the chart.
*/}}
{{- define "besu.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "besu.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "besu.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "besu.labels" -}}
helm.sh/chart: {{ include "besu.chart" . }}
{{ include "besu.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "besu.selectorLabels" -}}
app.kubernetes.io/name: {{ include "besu.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "besu.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "besu.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define bootnodes array (multiline)
*/}}
{{- define "besu.config.bootnodes" -}}
{{- "bootnodes = [" }}
{{- range $index, $value := .Values.config.bootnodes }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{ quote $value }}
  {{- end }}
{{ "]" }}
{{- end }}

{{/*
Define host-allowlist array (oneline)
*/}}
{{- define "besu.config.hostAllowlist" -}}
{{- "host-allowlist = [" }}
{{- range $index, $value := .Values.config.hostAllowlist }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{- quote $value }}
  {{- end }}
{{- "]" }}
{{- end }}

{{/*
Define rpc-http-api array (oneline)
*/}}
{{- define "besu.config.rpcHttpApi" -}}
{{- "rpc-http-api = [" }}
{{- range $index, $value := .Values.config.rpcHttpApi }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{- quote $value }}
  {{- end }}
{{- "]" }}
{{- end }}

{{/*
Define rpc-http-cors-origins array (oneline)
*/}}
{{- define "besu.config.rpcHttpCorsOrigins" -}}
{{- "rpc-http-cors-origins = [" }}
{{- range $index, $value := .Values.config.rpcHttpCorsOrigins }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{- quote $value }}
  {{- end }}
{{- "]" }}
{{- end }}

{{/*
Define rpc-ws-api array (oneline)
*/}}
{{- define "besu.config.rpcWsApi" -}}
{{- "rpc-ws-api = [" }}
{{- range $index, $value := .Values.config.rpcWsApi }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{- quote $value }}
  {{- end }}
{{- "]" }}
{{- end }}

{{/*
Define graphql-http-cors-origins array (oneline)
*/}}
{{- define "besu.config.graphqlHttpCorsOrigins" -}}
{{- "graphql-http-cors-origins = [" }}
{{- range $index, $value := .Values.config.graphqlHttpCorsOrigins }}
  {{- if $index }}{{- ", " }}{{- end }}
  {{- quote $value }}
  {{- end }}
{{- "]" }}
{{- end }}