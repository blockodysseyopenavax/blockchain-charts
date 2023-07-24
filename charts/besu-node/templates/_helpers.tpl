{{- /* Define the toEnodePublicKey function */}}
{{- define "toEnodePublicKey" }}
{{- $publicKey := . }}
{{- if hasPrefix "0x" $publicKey }}
{{-   $publicKey := trimPrefix "0x" $publicKey }}
{{- end }}
{{- if and (hasPrefix "04" $publicKey) (eq (len $publicKey) 130) }}
{{-   $publicKey := trimPrefix "04" $publicKey }}
{{- end }}
{{- $publicKey }}
{{- end }}