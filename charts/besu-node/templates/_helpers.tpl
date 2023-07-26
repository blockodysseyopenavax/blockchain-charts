{{/*
Expand the name of the chart.
*/}}
{{- define "besu-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "besu-node.fullname" -}}
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
{{- define "besu-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "besu-node.labels" -}}
helm.sh/chart: {{ include "besu-node.chart" . }}
{{ include "besu-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "besu-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "besu-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "besu-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "besu-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- /* Define the toEnodePublicKey function */}}
{{- define "besu-node.toEnodePublicKey" }}
{{- $publicKey := . }}
{{- if hasPrefix "0x" $publicKey }}
{{-   $publicKey = trimPrefix "0x" $publicKey }}
{{- end }}
{{- if and (hasPrefix "04" $publicKey) (eq (len $publicKey) 130) }}
{{-   $publicKey = trimPrefix "04" $publicKey }}
{{- end }}
{{- $publicKey }}
{{- end }}
