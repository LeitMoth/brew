# typed: strict
# frozen_string_literal: true

module SharedEnvExtension
  extend T::Sig

  def setup_build_environment(formula: nil, cc: nil, build_bottle: false, bottle_arch: nil, testing_formula: false)
    generic_shared_setup_build_environment(
      formula: formula, cc: cc, build_bottle: build_bottle,
      bottle_arch: bottle_arch, testing_formula: testing_formula
    )

    # Normalise the system Perl version used, where multiple may be available
    self["VERSIONER_PERL_VERSION"] = MacOS.preferred_perl_version

    #Colin's hack: correctly set the DEVELOPER_DIR before building
    self["DEVELOPER_DIR"] = MacOS.active_developer_dir
  end

  sig { returns(T::Boolean) }
  def no_weak_imports_support?
    return false unless compiler == :clang

    return false if !MacOS::Xcode.version.null? && MacOS::Xcode.version < "8.0"
    return false if !MacOS::CLT.version.null? && MacOS::CLT.version < "8.0"

    true
  end
end
