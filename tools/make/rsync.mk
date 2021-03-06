#################################################################
## RSYNC													   ##
#################################################################

RSYNCVERSION := $(shell cat $(SOURCES) | jq -r '.rsync.version' )
RSYNCARCHIVE := $(shell cat $(SOURCES) | jq -r '.rsync.archive' )
RSYNCURI     := $(shell cat $(SOURCES) | jq -r '.rsync.uri' )


#################################################################
##                                                             ##
#################################################################

$(SOURCEDIR)/$(RSYNCARCHIVE): $(SOURCEDIR)
	$(call box,"Downloading rsync source code")
	test -f $@ || $(DOWNLOADCMD) $@ $(RSYNCURI) || rm -f $@


#################################################################
##                                                             ##
#################################################################

$(BUILDDIR)/rsync: $(PREFIXDIR)/bin $(SOURCEDIR)/$(RSYNCARCHIVE)
	$(call box,"Building rsync")
	@mkdir -p $(BUILDDIR) && rm -rf $@-$(RSYNCVERSION)
	@tar -xzf $(SOURCEDIR)/$(RSYNCARCHIVE) -C $(BUILDDIR)
	@cd $@-$(RSYNCVERSION)				\
	&& $(BUILDENV)					\
		./configure				\
			--host=$(TARGET)		\
			--target=$(TARGET)		\
		&& make -j$(PROCS)			\
		&& cp rsync $(PREFIXDIR)/bin/rsync
	@rm -rf $(BUILDDIR)/$@-$(RSYNCVERSION)
	@touch $@


#################################################################
##                                                             ##
#################################################################
