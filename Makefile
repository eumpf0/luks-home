ODIR := /usr/local/bin

${ODIR}/luks-home: luks-home
	install -g root -o root -m 750 $^ $@

.PHONY: pam

pam: ${ODIR}/luks-home /etc/pam.d/system-login
	sed -i -E '/^auth\s+include\s+system-auth$$/a auth       optional   pam_exec.so          expose_authtok ${ODIR}/luks-home' /etc/pam.d/system-login
